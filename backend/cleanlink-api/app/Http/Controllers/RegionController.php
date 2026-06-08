<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;
use App\Models\regions;
use App\Traits\ApiResponse;

class RegionController extends Controller
{
    use ApiResponse;

    public function index()
    {
        $regions = regions::all();
        return $this->apiResponse($regions, 'Regions retrieved successfully', 200);
    }

    public function show($id)
    {
        $region = regions::with('companies')->find($id);

        if (! $region) {
            return $this->apiError('Region not found', 404);
        }

        return $this->apiResponse($region, 'Region retrieved successfully', 200);
    }
}
