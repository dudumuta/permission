package com.vdian.flutter.plugin.permission.utils


import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import com.vdian.flutter.plugin.permission.data.PermissionGroup
import com.vdian.flutter.plugin.permission.data.PermissionStatus

class Codec {
    companion object {
        @JvmStatic
        private val gsonDecoder : Gson = GsonBuilder().enableComplexMapKeySerialization().create()

        @JvmStatic
        fun decodePermissionGroup(arguments: Any) : PermissionGroup {
            return Codec.gsonDecoder.fromJson(arguments.toString(), PermissionGroup::class.java)
        }

        @JvmStatic
        fun decodePermissionGroups(arguments: Any) : Array<PermissionGroup> {

            var permissionGroupsType = object: TypeToken<Array<PermissionGroup>>() {}.type
            return Codec.gsonDecoder.fromJson(arguments.toString(), permissionGroupsType)
        }

        @JvmStatic
        fun encodePermissionStatus(permissionStatus: PermissionStatus) : String {
            return gsonDecoder.toJson(permissionStatus)
        }

        @JvmStatic
        fun encodePermissionRequestResult(permissionResults: Map<PermissionGroup, PermissionStatus>) : String {
            val jsonString = gsonDecoder.toJson(permissionResults)
            return jsonString
        }
    }
}