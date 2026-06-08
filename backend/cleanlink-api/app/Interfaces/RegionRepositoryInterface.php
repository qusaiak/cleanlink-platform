<?php

namespace App\Interfaces;

interface RegionRepositoryInterface
{
    public function create(array $data);
    public function delete($id);

}
