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
        Schema::create('price_for_government_institutions', function (Blueprint $table) {
            $table->id();
            
            $table->foreignId('service_id')->constrained('company_services')->onDelete('cascade');
            $table->unsignedInteger('price_government_institutions_category'); 
            $table->unsignedInteger('worker_wage');
            $table->unsignedInteger('builtup_cleaning_price_per_square_meter');
            $table->unsignedInteger('price_for_off_office_claeaning');
            $table->unsignedInteger('price_for_completed_office');
            $table->unsignedInteger('price_for_floor_cleaning');
            $table->unsignedInteger('price_for_garage_area_claening');
            $table->unsignedInteger('price_for_additional_services');
            $table->unsignedInteger('price_for_bathroom_cleaning');
            $table->unsignedInteger('price_per_square_meter_for_garden_cleaning');
            $table->unsignedInteger('price_for_interface_claening');
            $table->unsignedInteger('price_for_additional_detail');
            $table->string('notes')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('price_for_government_institutions');
    }
};
