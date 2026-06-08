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
        Schema::create('price_for_carpet_services', function (Blueprint $table) {
            $table->id();
            
            $table->foreignId('service_id')->constrained('company_services')->onDelete('cascade');
            $table->String('service_type');
            $table->string('carpet_type');
            $table->unsignedInteger('price_per_square_meter');
            $table->unsignedInteger('duration_working')->nullable();
            $table->string('notes')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('price_for_carpet_services');
    }
};
