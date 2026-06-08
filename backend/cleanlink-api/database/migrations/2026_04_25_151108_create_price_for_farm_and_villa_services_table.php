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
        Schema::create('price_for_farm_and_villa_services', function (Blueprint $table) {
            $table->id();
            $table->foreignId('service_id')->constrained('company_services')->onDelete('cascade');
            $table->unsignedInteger('price_per_square_meter_for_garden_cleaning');
            $table->unsignedInteger('builtup_cleaning_price_per_square_meter');
            $table->unsignedInteger('pool_cleaning_price');
            $table->unsignedInteger('room_cleaning_price');
            $table->unsignedInteger('bathroom_cleaning_price');
            $table->unsignedInteger('worker_wage');
            $table->unsignedInteger('tree_trimming_price');
            $table->unsignedInteger('additional_fees');
            $table->string('notes')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('price_for_farm_and_villa_services');
    }
};
