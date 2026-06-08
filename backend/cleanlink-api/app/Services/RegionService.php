<?php

namespace App\Services;

use App\Interfaces\RegionRepositoryInterface;

class RegionService
{
    protected $regionRepository;

    public function __construct(RegionRepositoryInterface $regionRepository)
    {
        $this->regionRepository = $regionRepository;
    }

    public function createRegion(array $data)
    {
        return $this->regionRepository->create($data);
    }

    public function deleteRegion($id)
    {
        return $this->regionRepository->delete($id);
    }
}
