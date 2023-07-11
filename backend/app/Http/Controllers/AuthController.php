<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use PHPOpenSourceSaver\JWTAuth\Exceptions\JWTException;
use PHPOpenSourceSaver\JWTAuth\Exceptions\TokenExpiredException;
use PHPOpenSourceSaver\JWTAuth\Exceptions\TokenInvalidException;



class AuthController extends Controller
{
    public function authenticate(Request $request)
    {
        $rules = [
            'username' => 'required',
            'password' => 'required',
        ];

        $request->validate($rules);

        $admin = Admin::where('username', $request->username)->first();
        if ($admin && Hash::check($request->password, $admin->password)) {
            $response = [
                "status" => 200,
                "error" => false,
                "messages" => "Data Saved Successfully!",
                "user" => $admin,
                "status" => $admin->status, // Menyertakan status pengguna dalam respons
                "session" => mt_rand(1, 100000000000000),
            ];
        } else {
            $response = [
                "status" => 400,
                "error" => true,
                "messages" => "Incorrect Email or Password!",
                "user" => [],
            ];
        }

        $hasil = response()->json($response);
        $token = $admin->createToken('user login')->plainTextToken;
        $response = array_merge($hasil->original, ['hasil2' => $token]);
        return response()->json($response);
    }
    public function logout(Request $request)
    {
        $request->admin()->currentAccessToken()->delete();
    }
}
