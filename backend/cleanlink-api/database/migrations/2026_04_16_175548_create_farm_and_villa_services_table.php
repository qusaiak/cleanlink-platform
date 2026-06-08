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
        Schema::create('farm_and_villa_services', function (Blueprint $table) {
            $table->id();
            $table->foreignId('service_id')->constrained('company_services')->onDelete('cascade');
            $table->unsignedInteger('garden_space');
            $table->unsignedInteger('builtup_space');
            $table->unsignedInteger('number_of_pools');
            $table->unsignedInteger('number_of_rooms');
            $table->String('service_type');
            $table->unsignedInteger('service_price');
            $table->unsignedInteger('number_of_bathrooms');
            $table->unsignedInteger('duration_working')->nullable();
            $table->boolean('tree_pruning');
            $table->string('notes')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('farm_and_villa_services');
    }
};
