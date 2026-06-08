<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserDevice;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class AuthController extends Controller
{
    use ApiResponse;

    
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'first_name' => 'required|string|max:255',
            'last_name'  => 'required|string|max:255',
            'email'      => 'required|string|email|unique:users',
            'number'     => 'required|string|unique:users',
            'password'   => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return $this->apiError($validator->errors()->first(), 422);
        }

        $user = User::create([
            'first_name' => $request->first_name,
            'last_name'  => $request->last_name,
            'email'      => $request->email,
            'number'     => $request->number,
            'role'       => 'client', // Forced role
            'password'   => Hash::make($request->password),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->apiResponse([
            'user' => $user,
            'access_token' => $token,
        ], 'Registration successful', 201);
    }

   
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            return $this->apiError($validator->errors()->first(), 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return $this->apiError('Invalid credentials', 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->apiResponse([
            'user' => $user,
            'access_token' => $token,
        ], 'Login successful');
    }

    
    public function updateFcm(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'fcm_token'   => 'required|string',
            'device_type' => 'required|string|in:android,ios,web',
            'is_primary'  => 'boolean'
        ]);

        if ($validator->fails()) {
            return $this->apiError($validator->errors()->first(), 422);
        }

        $user = $request->user();

        // Update existing device if type matches, otherwise create new
        $device = UserDevice::updateOrCreate(
            [
                'user_id' => $user->id,
                'device_type' => $request->device_type
            ],
            [
                'fcm_token' => $request->fcm_token,
                'is_primary' => $request->is_primary ?? true
            ]
        );

        return $this->apiResponse($device, 'FCM token updated successfully');
    }

    
    public function me(Request $request)
    {
        // Loading devices relationship for full profile info
        return $this->apiResponse(
            $request->user()->load('devices'), 
            'User data retrieved'
        );
    }

 public function logout(Request $request)
{
    /** @var \Laravel\Sanctum\PersonalAccessToken $token */
    $token = $request->user()->currentAccessToken();
    $token->delete();

    return $this->apiResponse(null, 'Logged out successfully');
}

}