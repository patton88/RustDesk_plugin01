#![allow(clippy::not_unsafe_ptr_arg_deref)]

use hbb_common::lazy_static;
use serde::{Deserialize, Serialize};
use serde_json::json;
use std::env;
use std::ffi::{c_char, c_void, CStr};
use std::fs;
use std::path::PathBuf;

#[repr(C)]
#[derive(Clone)]
pub struct Callbacks {
    pub push_msg: extern "C" fn(
        name: *const c_char,
        data: *const c_void,
        len: usize,
    ) -> i32,
}

#[repr(C)]
pub struct InitData {
    pub cbs: Callbacks,
}

#[repr(C)]
pub struct PluginReturn {
    ok: bool,
    len: usize,
    data: *const c_void,
}

impl PluginReturn {
    fn success() -> Self {
        Self {
            ok: true,
            len: 0,
            data: std::ptr::null(),
        }
    }

    fn err(msg: &str) -> Self {
        let bytes = msg.as_bytes();
        Self {
            ok: false,
            len: bytes.len(),
            data: bytes.as_ptr() as *const c_void,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
struct UiConfig {
    fullscreen: Option<bool>,
    scale: Option<String>,
    toolbar: Option<String>,
}

lazy_static::lazy_static! {
    static ref PLUGIN_ID: String = "rd_ui_plugin".to_string();
}

static mut CBS: Option<Callbacks> = None;

#[no_mangle]
pub extern "C" fn init(data: *const InitData) -> PluginReturn {
    unsafe {
        if let Some(init_data) = data.as_ref() {
            CBS = Some(init_data.cbs.clone());
            println!("[rd_ui_plugin] Plugin initialized successfully");
            PluginReturn::success()
        } else {
            println!("[rd_ui_plugin] Failed to initialize plugin: null data");
            PluginReturn::err("Failed to initialize plugin: null data")
        }
    }
}

#[no_mangle]
pub extern "C" fn desc() -> PluginReturn {
    let desc = json!({
        "id": PLUGIN_ID.as_str(),
        "name": "RustDesk UI Control Plugin",
        "version": "1.0.0",
        "description": "Control remote desktop UI behavior (fullscreen, scaling, toolbar)",
        "author": "Claude",
        "homepage": "https://github.com/rustdesk/rustdesk"
    });
    
    let desc_str = desc.to_string();
    let bytes = desc_str.as_bytes();
    
    PluginReturn {
        ok: true,
        len: bytes.len(),
        data: bytes.as_ptr() as *const c_void,
    }
}

#[no_mangle]
pub extern "C" fn reset() -> PluginReturn {
    println!("[rd_ui_plugin] Plugin reset called");
    PluginReturn::success()
}

#[no_mangle]
pub extern "C" fn clear() -> PluginReturn {
    println!("[rd_ui_plugin] Plugin clear called");
    PluginReturn::success()
}

#[no_mangle]
pub extern "C" fn call(
    method: *const c_char,
    _peer: *const c_char,
    args: *const c_void,
    len: usize,
) -> PluginReturn {
    let method = unsafe { CStr::from_ptr(method) }.to_string_lossy().to_string();
    
    println!("[rd_ui_plugin] Plugin call: method={}, args_len={}", method, len);
    
    if method == "handle_listen_event" {
        let bytes = unsafe { std::slice::from_raw_parts(args as *const u8, len) };
        
        match serde_json::from_slice::<serde_json::Value>(bytes) {
            Ok(v) => {
                if let Some(event) = v.get("event").and_then(|x| x.as_str()) {
                    println!("[rd_ui_plugin] Event received: {}", event);
                    
                    if event == "on_conn_client" {
                        println!("[rd_ui_plugin] Connection event detected, applying UI settings");
                        if let Err(e) = apply_settings() {
                            println!("[rd_ui_plugin] Error applying settings: {}", e);
                            return PluginReturn::err(&e);
                        }
                    }
                }
            }
            Err(e) => {
                println!("[rd_ui_plugin] Failed to parse event data: {}", e);
                return PluginReturn::err(&format!("Failed to parse event data: {}", e));
            }
        }
        
        return PluginReturn::success();
    }
    
    PluginReturn::success()
}

fn load_settings() -> UiConfig {
    // Try environment variables first
    let mut config = UiConfig::default();
    
    if let Ok(fs) = env::var("RUSTDESK_FULLSCREEN") {
        if let Ok(b) = fs.parse::<bool>() {
            config.fullscreen = Some(b);
        }
    }
    
    if let Ok(scale) = env::var("RUSTDESK_SCALE") {
        config.scale = Some(scale);
    }
    
    if let Ok(toolbar) = env::var("RUSTDESK_TOOLBAR") {
        config.toolbar = Some(toolbar);
    }
    
    // Try config file
    let config_path = get_config_path();
    if let Ok(contents) = fs::read_to_string(&config_path) {
        if let Ok(file_config) = serde_json::from_str::<UiConfig>(&contents) {
            if config.fullscreen.is_none() {
                config.fullscreen = file_config.fullscreen;
            }
            if config.scale.is_none() {
                config.scale = file_config.scale;
            }
            if config.toolbar.is_none() {
                config.toolbar = file_config.toolbar;
            }
        }
    }
    
    println!("[rd_ui_plugin] Loaded config: {:?}", config);
    config
}

fn get_config_path() -> PathBuf {
    // Try current directory first
    let current_config = PathBuf::from("plugins/rd_ui_plugin/config.json");
    if current_config.exists() {
        return current_config;
    }
    
    // Try ProgramData
    let program_data = env::var("ProgramData").unwrap_or_else(|_| "C:\\ProgramData".to_string());
    PathBuf::from(program_data).join("RustDesk/plugins/rd_ui_plugin/config.json")
}

fn push_global(name: &str, payload: serde_json::Value) {
    unsafe {
        if let Some(cbs) = &CBS {
            let name_cstr = std::ffi::CString::new(name).unwrap();
            let payload_str = payload.to_string();
            let payload_bytes = payload_str.as_bytes();
            
            println!("[rd_ui_plugin] Pushing global message: {} = {}", name, payload_str);
            
            let result = (cbs.push_msg)(
                name_cstr.as_ptr(),
                payload_bytes.as_ptr() as *const c_void,
                payload_bytes.len(),
            );
            
            if result != 0 {
                println!("[rd_ui_plugin] Warning: push_msg returned {}", result);
            }
        } else {
            println!("[rd_ui_plugin] Error: Callbacks not available");
        }
    }
}

fn apply_settings() -> Result<(), String> {
    let cfg = load_settings();
    
    println!("[rd_ui_plugin] Applying UI settings: {:?}", cfg);
    
    // Apply scale setting
    if let Some(scale) = cfg.scale.clone() {
        println!("[rd_ui_plugin] Setting scale to: {}", scale);
        push_global(
            "plugin_config_option",
            json!({
                "key": "option.view_style",
                "value": scale
            }),
        );
    }
    
    // Apply toolbar setting
    if let Some(toolbar) = cfg.toolbar.clone() {
        println!("[rd_ui_plugin] Setting toolbar to: {}", toolbar);
        push_global(
            "plugin_config_option",
            json!({
                "key": "option.toolbar",
                "value": toolbar
            }),
        );
    }
    
    // Apply fullscreen setting
    if let Some(fs) = cfg.fullscreen {
        if fs {
            println!("[rd_ui_plugin] Setting fullscreen mode");
            push_global(
                "plugin_ui_event",
                json!({
                    "action": "fullscreen",
                    "enabled": true
                }),
            );
        }
    }
    
    println!("[rd_ui_plugin] UI settings applied successfully");
    Ok(())
}
