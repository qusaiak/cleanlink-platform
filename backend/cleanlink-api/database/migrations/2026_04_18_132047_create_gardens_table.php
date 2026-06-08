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
        Schema::create('gardens', function (Blueprint $table) {
            $table->id();
            $table->foreignId('service_id')->constrained('company_services')->onDelete('cascade');
            $table->unsignedInteger('garden_space');
            $table->String('service_type');
            $table->unsignedInteger('service_price');
            $table->string('garden_type');
            $table->unsignedInteger('duration_working')->nullable();
            $table->boolean('tree_pruning');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('gardens');
    }
};
