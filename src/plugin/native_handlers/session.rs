use std::{
    collections::HashMap,
    ffi::{c_char, c_void},
    ptr::addr_of_mut,
    sync::{Arc, RwLock},
};

use flutter_rust_bridge::StreamSink;
use crate::flutter_ffi::SessionID;
use std::str::FromStr;
use hbb_common::rendezvous_proto::ConnType;

use crate::{define_method_prefix, flutter_ffi::EventToUI};

const MSG_TO_UI_TYPE_SESSION_CREATED: &str = "session_created";

use super::PluginNativeHandler;

pub type OnSessionRgbaCallback = unsafe extern "C" fn(
    *const c_char,           // Session ID
    *mut c_void,             // raw data
    *mut usize,              // width
    *mut usize,              // height,
    *mut usize,              // stride,
    *mut scrap::ImageFormat, // ImageFormat
);

#[derive(Default)]
/// Session related handler for librustdesk core.
pub struct PluginNativeSessionHandler {
    sessions: Arc<RwLock<Vec<crate::flutter::FlutterSession>>>,
    cbs: Arc<RwLock<HashMap<String, OnSessionRgbaCallback>>>,
}

lazy_static::lazy_static! {
    pub static ref SESSION_HANDLER: Arc<PluginNativeSessionHandler> = Arc::new(PluginNativeSessionHandler::default());
}

impl PluginNativeHandler for PluginNativeSessionHandler {
    define_method_prefix!("session_");

    fn on_message(
        &self,
        method: &str,
        data: &serde_json::Map<String, serde_json::Value>,
    ) -> Option<super::NR> {
        match method {
            "create_session" => {
                if let Some(id) = data.get("id") {
                    if let Some(id) = id.as_str() {
                        return Some(super::NR {
                            return_type: 1,
                            data: SESSION_HANDLER.create_session(id.to_string()).as_ptr() as _,
                        });
                    }
                }
            }
            "start_session" => {
                if let Some(id) = data.get("id") {
                    if let Some(id) = id.as_str() {
                        let sessions = SESSION_HANDLER.sessions.read().unwrap();
                        for session in sessions.iter() {
                            if session.id == id {
                                let round =
                                    session.connection_round_state.lock().unwrap().new_round();
                                // io_loop expects Session<T>, not Arc<Session<T>>
                                let session_deref = (*session).clone();
                                tokio::spawn(async move {
                                    crate::ui_session_interface::io_loop(session_deref, round).await;
                                });
                            }
                        }
                    }
                }
            }
            "remove_session_hook" => {
                if let Some(id) = data.get("id") {
                    if let Some(id) = id.as_str() {
                        SESSION_HANDLER.remove_session_hook(id.to_string());
                        return Some(super::NR {
                            return_type: 0,
                            data: std::ptr::null(),
                        });
                    }
                }
            }
            "remove_session" => {
                if let Some(id) = data.get("id") {
                    if let Some(id) = id.as_str() {
                        SESSION_HANDLER.remove_session(id.to_owned());
                        return Some(super::NR {
                            return_type: 0,
                            data: std::ptr::null(),
                        });
                    }
                }
            }
            _ => {}
        }
        None
    }

    fn on_message_raw(
        &self,
        method: &str,
        data: &serde_json::Map<String, serde_json::Value>,
        raw: *const std::ffi::c_void,
        _raw_len: usize,
    ) -> Option<super::NR> {
        match method {
            "add_session_hook" => {
                if let Some(id) = data.get("id") {
                    if let Some(id) = id.as_str() {
                        let cb: OnSessionRgbaCallback = unsafe { std::mem::transmute(raw) };
                        SESSION_HANDLER.add_session_hook(id.to_string(), cb);
                        return Some(super::NR {
                            return_type: 0,
                            data: std::ptr::null(),
                        });
                    }
                }
            }
            _ => {}
        }
        None
    }
}

impl PluginNativeSessionHandler {
    fn create_session(&self, session_id: String) -> String {
        // Find existing session by SessionID; do not create a new session here.
        if let Ok(sid) = SessionID::from_str(&session_id) {
            if let Some(session) = crate::flutter::sessions::get_session_by_session_id(&sid) {
                let mut sessions = self.sessions.write().unwrap();
                sessions.push(session);
                let mut m = HashMap::new();
                m.insert("name", MSG_TO_UI_TYPE_SESSION_CREATED);
                m.insert("session_id", &session_id);
                let _ = crate::flutter::push_global_event(
                    crate::flutter::APP_TYPE_DESKTOP_REMOTE,
                    serde_json::to_string(&m).unwrap_or("".to_string()),
                );
                return session_id;
            }
        }
        "".to_string()
    }

    fn add_session_hook(&self, session_id: String, cb: OnSessionRgbaCallback) {
        if let Ok(sid) = SessionID::from_str(&session_id) {
            self.cbs.write().unwrap().insert(session_id.to_owned(), cb);
            if let Some(session) = crate::flutter::sessions::get_session_by_session_id(&sid) {
                session.ui_handler.add_session_hook(
                    session_id,
                    crate::flutter::SessionHook::OnSessionRgba(session_rgba_cb),
                );
            }
        }
    }

    fn remove_session_hook(&self, session_id: String) {
        if let Ok(sid) = SessionID::from_str(&session_id) {
            if let Some(session) = crate::flutter::sessions::get_session_by_session_id(&sid) {
                session.ui_handler.remove_session_hook(&session_id);
            }
        }
    }

    fn remove_session(&self, session_id: String) {
        let _ = self.cbs.write().unwrap().remove(&session_id);
        if let Ok(sid) = SessionID::from_str(&session_id) {
            let _ = crate::flutter::sessions::remove_session_by_session_id(&sid);
        }
    }

    #[inline]
    // The callback function for rgba data
    fn session_rgba_cb(&self, session_id: String, rgb: &mut scrap::ImageRgb) {
        let cbs = self.cbs.read().unwrap();
        if let Some(cb) = cbs.get(&session_id) {
            unsafe {
                cb(
                    session_id.as_ptr() as _,
                    rgb.raw.as_mut_ptr() as _,
                    addr_of_mut!(rgb.w),
                    addr_of_mut!(rgb.h),
                    addr_of_mut!(rgb.align),
                    addr_of_mut!(rgb.fmt),
                );
            }
        }
    }

    #[inline]
    // The callback function for rgba data
    fn session_register_event_stream(&self, session_id: String, stream: StreamSink<EventToUI>) {
        if let Ok(sid) = SessionID::from_str(&session_id) {
            // Register stream via flutter API; id is only used for logs
            let _ = crate::flutter::session_start_(&sid, "", stream);
        }
    }
}

#[inline]
fn session_rgba_cb(id: String, rgb: &mut scrap::ImageRgb) {
    SESSION_HANDLER.session_rgba_cb(id, rgb);
}

#[inline]
pub fn session_register_event_stream(id: String, stream: StreamSink<EventToUI>) {
    SESSION_HANDLER.session_register_event_stream(id, stream);
}
