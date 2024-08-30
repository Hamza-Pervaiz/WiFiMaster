package com.example.masterwifi

import android.content.Context
import android.content.pm.PackageManager
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.masterwifi/hotspot"
    private var hotspotReservation: WifiManager.LocalOnlyHotspotReservation? = null

    // Permission request code
    private val MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION = 1

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "createHotspot" -> {
                        if (checkLocationPermission()) {
                            createHotspot(result)
                        } else {
                            result.error("PERMISSION_DENIED", "Location permission is required", null)
                        }
                    }
                    "stopHotspot" -> {
                        stopHotspot(result)
                    }
                    "scanDevices" -> {
                        if (checkLocationPermission()) {
                            val connectedDevices = scanConnectedDevices()
                            result.success(connectedDevices)
                        } else {
                            result.error("PERMISSION_DENIED", "Location permission is required", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun createHotspot(result: MethodChannel.Result) {
        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            wifiManager.startLocalOnlyHotspot(object : WifiManager.LocalOnlyHotspotCallback() {
                override fun onStarted(reservation: WifiManager.LocalOnlyHotspotReservation) {
                    super.onStarted(reservation)
                    hotspotReservation = reservation
                    val config = reservation.wifiConfiguration
                    result.success("Hotspot created: SSID=${config?.SSID}, Password=${config?.preSharedKey}")
                }

                override fun onStopped() {
                    super.onStopped()
                    Toast.makeText(applicationContext, "Hotspot stopped", Toast.LENGTH_SHORT).show()
                }

                override fun onFailed(reason: Int) {
                    super.onFailed(reason)
                    result.error("ERROR", "Failed to start hotspot: $reason", null)
                }
            }, null)
        } else {
            result.error("ERROR", "LocalOnlyHotspot is not supported on this Android version", null)
        }
    }

    private fun stopHotspot(result: MethodChannel.Result) {
        hotspotReservation?.close()
        hotspotReservation = null
        result.success("Hotspot stopped")
    }

    private fun scanConnectedDevices(): List<Map<String, String>> {
        val connectedDevices = mutableListOf<Map<String, String>>()

        if (!checkLocationPermission()) {
            Log.e("scanDevices", "Location permission is required to scan connected devices")
            return connectedDevices
        }

        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val wifiInfo = wifiManager.connectionInfo

        val networkInfo = mapOf(
            "SSID" to wifiInfo.ssid,
            "BSSID" to wifiInfo.bssid,
            "IP Address" to convertIpToString(wifiInfo.ipAddress)
        )

        connectedDevices.add(networkInfo)
        return connectedDevices
    }

    private fun convertIpToString(ipAddress: Int): String {
        return String.format(
            "%d.%d.%d.%d",
            (ipAddress and 0xFF),
            (ipAddress shr 8 and 0xFF),
            (ipAddress shr 16 and 0xFF),
            (ipAddress shr 24 and 0xFF)
        )
    }

    private fun checkLocationPermission(): Boolean {
        return ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
    }
}
