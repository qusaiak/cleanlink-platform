<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
{
    Schema::create('user_devices', function (Blueprint $table) {
        $table->id();
        $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
        $table->string('device_type');
        $table->string('fcm_token')->unique();
        $table->boolean('is_primary')->default(false);
        $table->timestamp('last_active_at')->nullable();
        $table->timestamps();
    });
}

public function down()
{
    Schema::dropIfExists('user_devices');
}


    /**
     * Reverse the migrations.
     */
    
};
