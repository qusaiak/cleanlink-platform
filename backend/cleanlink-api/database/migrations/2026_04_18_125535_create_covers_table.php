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
        Schema::create('covers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('service_id')->constrained('company_services')->onDelete('cascade');
            $table->String('service_type');
            $table->string('cover_type');
             $table->unsignedInteger('duration_working')->nullable();
            $table->unsignedInteger('weight');
            $table->unsignedInteger('service_price');
            $table->string('notes')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('covers');
    }
};
