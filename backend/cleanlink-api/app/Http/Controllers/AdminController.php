<?php

namespace App\Http\Controllers;

use App\Models\regions;
use App\Models\User;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    use ApiResponse;
    public function addRegion(Request $request)
    {
        $this->validate($request, [
            'name' => 'required|string|max:255',
        ]);
        $user = $request->user();
        $region = regions::create([
            'name' => $request->name,
            'created_by' => $user->id
        ]);
        return $this->apiResponse($region, 'Region added successfully', 200);
    }
    public function editRegion(Request $request)
    {
        $this->validate($request, [
            'id' => 'required|exists:regions,id',
            'name' => 'required|string|max:255',
        ]);
        $region = regions::find($request->id);
        $region->name = $request->name;
        $region->save();
        return $this->apiResponse($region, 'Region updated successfully', 200);
    }
    public function deleteRegion(Request $request)
    {
        $this->validate($request, [
            'id' => 'required|exists:regions,id',
        ]);
        $region = regions::find($request->id);
        $region->delete();
        return $this->apiResponse(null, 'Region deleted successfully', 200);
    }
    public function addRegionAdmin(Request $request)
    {
        $this->validate($request, [
            'region_id' => 'required|exists:regions,id',
            'first_name' => 'required|string|max:255',
            'last_name'  => 'required|string|max:255',
            'email'      => 'required|string|email|unique:users',
            'number'     => 'required|string|unique:users',
            'password'   => 'required|string|min:8|confirmed',
        ]);
        $user = User::create([
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'email' => $request->email,
            'number' => $request->number,
            'password' => bcrypt($request->password)
        ]);
        $region = regions::find($request->region_id);
        $region->regionAdmins()->attach($user->id);
        return $this->apiResponse($user, 'Region admin added successfully', 200);
    }
}
