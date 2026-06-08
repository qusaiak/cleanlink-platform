<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use PhpParser\Node\Expr\Cast\String_;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'first_name',
        'last_name',
        'number',
        'role',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];
    public function getFullNameAttribute():String
    {
        return "{$this->first_name}{$this->last_name}";
    }
    public function hasRole(String $role):bool
    {
        return $this->role===$role;
    }
    public function isSuperAdmin():bool
    {
        return $this->role==='super_admin';
    }
    public function isRegionAdmin():bool
    {
        return $this->role==='region_admin';
    }
    public function isCompanyAdmin():bool
    {
        return $this->role==='company_admin';
    }
    public function isWorker():bool
    {
        return $this->role==='worker';
    }
    public function isClient():bool
    {
        return $this->role==='client';
    }
    public function regions()
    {
        return $this->hasMany(regions::class,'created_by');
    }
public function devices()
{
    return $this->hasMany(UserDevice::class);
}
public function regionAdmins()
{
    return $this->belongsToMany(regions::class,'region_admins','user_id','region_id');

}
public function companyAdmins()
{
    return $this->belongsToMany(companies::class,'company_admins','user_id','company_id');
}
public function companies()
{
    return $this->belongsToMany(companies::class,'company_employees','user_id','company_id');
}
}