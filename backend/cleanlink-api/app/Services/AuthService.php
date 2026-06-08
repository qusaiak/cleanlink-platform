<?php
namespace App\Services;
 
use App\Interfaces\UserRepositoryInterface;
use Illuminate\Support\Facades\Hash;

class AuthService
{
    protected $users;

    public function __construct(UserRepositoryInterface $users) 
    {
        $this->users = $users;
    }

    public function login(array $data)
{
    $user = $this->users->findByEmail($data['email']);

    if (! $user || ! Hash::check($data['password'], $user->password)) {
        throw new \Exception('بيانات الدخول غير صحيحة');
    }

    // حذف الأجهزة القديمة
    $user->devices()->delete();

    // حذف التوكنات القديمة
    $user->tokens()->delete();

    // إنشاء توكن جديد
    $token = $user->createToken('auth')->plainTextToken;

    // تسجيل الجهاز الجديد
    $user->devices()->create([
        'device_type' => $data['device_type'],
        'device_model' => $data['device_model'] ?? null,
        'fcm_token' => $data['fcm_token'],
        'last_active_at' => now(),
    ]);

    return [
        'message' => 'Login successful',
        'token' => $token,
        'user' => $user
    ];
}

}
