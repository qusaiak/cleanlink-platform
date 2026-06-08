<?php

use App\Http\Controllers\AdminController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CompanyAdminController;
use App\Http\Controllers\RegionController;
use App\Http\Controllers\RegionManagerController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Authenticated routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/update-fcm', [AuthController::class, 'updateFcm']);
    // Admin routes
    Route::post('/add_region', [AdminController::class,'addRegion']);
    Route::post('/add_region_admin', [AdminController::class,'addRegionAdmin']);
    Route::put('/edit_region', [AdminController::class,'editRegion']);
     Route::delete('/delete_region', [AdminController::class,'deleteRegion']);
     //Region manager routes
     Route::post('/add_company', [RegionManagerController::class,'addCompanyToRegion']);
     Route::post('/add_company_manager', [RegionManagerController::class,'addCompanyAdmin']);
     Route::put('/edit_company', [RegionManagerController::class,'updateCompany']);
     Route::delete('/delete_company', [RegionManagerController::class,'deleteCompany']);
     // Company manager routes
     Route::post('/add_worker', [CompanyAdminController::class,'AddWorkertoCompany']);
     Route::delete('/delete_worker', [CompanyAdminController::class,'deleteWorker']);
     // Region routes
        Route::get('/regions', [RegionController::class,'index']);
        Route::get('/regions/{id}', [RegionController::class,'show']);
});

