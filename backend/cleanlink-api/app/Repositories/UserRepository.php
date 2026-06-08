<?php

namespace App\Repositories;

use App\Interfaces\UserRepositoryInterface;
use App\Models\User;

class UserRepository implements UserRepositoryInterface
{   protected $users;

    public function findByEmail(string $email)
    {
         return User::where('email', $email)->first();
    }
}
