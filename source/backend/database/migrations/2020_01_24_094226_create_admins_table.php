<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAdminsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('admins', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name')->default('admin');
            $table->string('userName')->default('admin');
            $table->string('email')->default('admin@gmail.com')->unique();
            $table->string('password')->default('$2y$10$2XjJVCbg92f1nC.zyLyjveQAFc7SQdqKpR6xZyEDrTi/dWaWF9NKm');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('admins');
    }
}
