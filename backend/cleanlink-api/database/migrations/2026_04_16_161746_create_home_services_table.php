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
        Schema::create('home_services', function (Blueprint $table) {
            $table->id();
            $table->foreignId('service_id')->constrained('company_services')->onDelete('cascade');
            $table->unsignedInteger('home_space');
            $table->unsignedInteger('number_of_balconies');
            $table->unsignedInteger('number_of_rooms');
            $table->boolean('the_house_is_empty');
            $table->String('service_type');
            $table->unsignedInteger('service_price');
            $table->unsignedInteger('number_of_bathrooms');
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
        Schema::dropIfExists('home_services');
    }
};
