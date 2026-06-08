<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class region_admins extends Model
{
    use HasFactory;
    protected $fillable = ['user_id','region_id'];
}
