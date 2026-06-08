<?php

namespace Database\Seeders;

use App\Models\User;
use Hash;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash as FacadesHash;

class SuperAdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create(['first_name'=>'Super',
        'last_name'=>'Admin',
        'number'=>'0988704367',
        'role'=>'super_admin',
        'email'=>'superadmin@system.com',
        'password'=>FacadesHash::make('password123')]);
    }
}
