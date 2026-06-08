<?php

namespace App\Repositories;

use App\Interfaces\RegionRepositoryInterface;
use App\Models\regions;

class RegionRepository implements RegionRepositoryInterface
{
    public function create(array $data)
    {
        return regions::create([
            'name'       => $data['name'],
            'created_by' => auth()->id(),
        ]);
    }

    public function delete($id)
    {
        return regions::where('id', $id)->delete();
    }
}
