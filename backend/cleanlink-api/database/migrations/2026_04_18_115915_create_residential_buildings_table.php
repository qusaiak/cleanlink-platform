<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('residential_buildings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('service_id')->constrained('company_services')->onDelete('cascade');
            $table->String('service_type'); 
            $table->string('residential_category')->nullable();
            $table->unsignedInteger('service_price');
            $table->unsignedInteger('duration_working')->nullable();
            $table->unsignedInteger('residential_buildings_space');
            $table->unsignedInteger('number_of_home');
            $table->unsignedInteger('number_of_floors');
            $table->unsignedInteger('garden_space')->nullable();
            $table->string('type_of_interface')->nullable();
            $table->string('notes')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('residential_buildings');
    }
};
