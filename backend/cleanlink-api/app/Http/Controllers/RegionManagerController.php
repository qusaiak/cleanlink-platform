<?php

namespace App\Http\Controllers;

use App\Models\companies;
use App\Models\regions;
use App\Models\User;
use Illuminate\Http\Request;
use App\Traits\ApiResponse;

class RegionManagerController extends Controller
{
    use ApiResponse;
    public function addCompanyToRegion(Request $request)
    {
        $this->validate($request, [
            'region_id' => 'required|exists:regions,id',
            'company_name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'commercial_register' => 'nullable|string|max:255',
            'health_registry' => 'nullable|string|max:255',
            'postion' => 'nullable|string|max:255',
            'is_available' => 'required|boolean',
            'is_open' => 'required|boolean',
        ]);
        $region = regions::find($request->region_id);
        $user = $request->user();
        $company = $region->companies()->create([
            'company_name' => $request->company_name,
            'description' => $request->description,
            'commercial_register' => $request->commercial_register,
            'health_registry' => $request->health_registry,
            'postion' => $request->postion,
            'is_available' => $request->is_available,
            'is_open' => $request->is_open,
            'created_by' => $user->id,
        ]);
        return $this->apiResponse($company, 'Company added to region successfully', 200);
    }
    public function updateCompany(Request $request)
    {
        $this->validate($request, [
            'company_id' => 'required|exists:companies,id',
            'company_name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'commercial_register' => 'nullable|string|max:255',
            'health_registry' => 'nullable|string|max:255',
            'postion' => 'nullable|string|max:255',
            'is_available' => 'required|boolean',
            'is_open' => 'required|boolean',
        ]);
        $company = companies::find($request->company_id);
        $company->update([
            'company_name' => $request->company_name,
            'description' => $request->description,
            'commercial_register' => $request->commercial_register,
            'health_registry' => $request->health_registry,
            'postion' => $request->postion,
            'is_available' => $request->is_available,
            'is_open' => $request->is_open,
        ]);
        return $this->apiResponse($company, 'Company updated successfully', 200);
    }
    public function deleteCompany(Request $request)
    {
        $this->validate($request, [
            'company_id' => 'required|exists:companies,id',
        ]);
        $company = companies::find($request->company_id);
        $company->delete();
        return $this->apiResponse(null, 'Company deleted successfully', 200);
    }
    public function addCompanyAdmin(Request $request)
    {
        $this->validate($request, [
            'company_id' => 'required|exists:companies,id',
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
        $company = companies::find($request->company_id);
        $company->companyAdmins()->attach($user->id);
        return $this->apiResponse($user, 'Company admin added successfully', 200);
    }
}
