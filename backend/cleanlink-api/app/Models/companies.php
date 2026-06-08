<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class companies extends Model
{
    use HasFactory;
    protected $fillable = [
        'company_name',
        'description',
        'commercial_register',
        'health_registry',
        'postion',
        'is_available',
        'is_open',
        'created_by'
    ];
    public function companyAdmins()
    {
        return $this->belongsToMany(User::class,'company_admins','company_id','user_id');
    }
    public function companyRegions()
    {
        return $this->belongsToMany(regions::class,'company_regions','company_id','region_id');
    }
    public function creator()
    {
        return $this->belongsTo(User::class,'created_by');
    }
    public function workers()
    {
        return $this->belongsToMany(User::class,'company_employees','company_id','user_id');
    }
}
