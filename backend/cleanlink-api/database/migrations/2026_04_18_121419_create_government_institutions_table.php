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
        Schema::create('government_institutions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('service_id')->constrained('company_services')->onDelete('cascade');
            $table->String('service_type'); 
            $table->string('government_institution_category')->nullable();
            $table->unsignedInteger('service_price');
            $table->unsignedInteger('duration_working')->nullable();
            $table->unsignedInteger('government_institution_buildings_space');
            $table->unsignedInteger('number_of_offices');
            $table->unsignedInteger('number_of_floors');
            $table->unsignedInteger('garden_space');
            $table->string('contract_duration');
            $table->unsignedInteger('garage_area')->nullable();
            $table->string('additional_services')->nullable();
            $table->string('type_of_interface')->nullable();
            $table->unsignedInteger('number_of_bathrooms');
            $table->string('notes')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('government_institutions');
    }
};
