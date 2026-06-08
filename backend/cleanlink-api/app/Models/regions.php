<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class regions extends Model
{
    use HasFactory;
    protected $fillable=['name','created_by'];
    public function creator()
    {
        return $this->belongsTo(User::class,'created_by');
    }
    public function regionAdmins()
    {
        return $this->belongsToMany(User::class,'region_admins','region_id','user_id');
    }
    public function companies()
    {
        return $this->belongsToMany(companies::class,'company_regions','region_id','company_id');
    }
}
