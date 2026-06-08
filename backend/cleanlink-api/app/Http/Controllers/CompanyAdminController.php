<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Traits\ApiResponse;

class CompanyAdminController extends Controller
{
    use ApiResponse;
   public function AddWorkertoCompany(Request $request)
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
       $user->companies()->attach($request->company_id);
       return $this->apiResponse($user, 'Worker added to company successfully', 200);
   }
   public function deleteWorker(Request $request)
   {
       $this->validate($request, [
           'user_id' => 'required|exists:users,id',
       ]);
       $user = User::find($request->user_id);
       $user->delete();
       return $this->apiResponse(null, 'Worker deleted successfully',200);
   }
}