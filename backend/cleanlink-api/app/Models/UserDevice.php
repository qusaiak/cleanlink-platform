<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserDevice extends Model
{
    protected $table = 'user_devices';

    protected $fillable = [
        'user_id',
        'device_type',
        'device_model',
        'fcm_token',
        'is_primary',
        'last_active_at',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
