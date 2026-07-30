package com.example.device_info // <-- Giữ nguyên dòng package gốc của bạn ở đây

import android.content.Context
import android.hardware.camera2.CameraManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // Tên channel khớp với bên Flutter
    private val CHANNEL = "com.hippo.hardware/advanced"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                // Lệnh 1: Lấy tên máy
                "getDeviceModel" -> {
                    val model = Build.MODEL
                    result.success(model)
                }
                
                // Lệnh 2: Bật tắt Flash
                "toggleFlashlight" -> {
                    val isOn = call.argument<Boolean>("isOn") ?: false
                    try {
                        val cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
                        val cameraId = cameraManager.cameraIdList[0]
                        cameraManager.setTorchMode(cameraId, isOn)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("FLASH_ERROR", "Không thể điều khiển đèn Flash", null)
                    }
                }
                
                // Lệnh 3: Check mạng Wifi
                "checkWifiStatus" -> {
                    val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                    val network = connectivityManager.activeNetwork
                    val capabilities = connectivityManager.getNetworkCapabilities(network)
                    val isWifi = capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true
                    result.success(isWifi)
                }
                
                // Trả về nếu tên hàm gõ sai
                else -> result.notImplemented()
            }
        }
    }
}