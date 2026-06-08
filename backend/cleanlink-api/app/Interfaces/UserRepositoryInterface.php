<?php

namespace App\Interfaces;

interface UserRepositoryInterface
{
    public function findByEmail(string $email);

}
