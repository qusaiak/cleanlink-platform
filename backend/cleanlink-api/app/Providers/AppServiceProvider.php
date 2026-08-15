<?php

namespace App\Providers;

use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // The worker app's data sources parse API responses as the flat
        // object (`WorkerProfileModel.fromJson(response.data)`), not
        // Laravel's default `{"data": {...}}` envelope. The login endpoint
        // still wraps its response manually (`AuthController::login`), which
        // this doesn't affect since that's a plain array, not a Resource.
        JsonResource::withoutWrapping();
    }
}
