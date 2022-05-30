<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->string('user_name');
            $table->string('state')->nullable();
            $table->string('city')->nullable();
            $table->string('address')->nullable();
            $table->string('zip_code')->nullable();
            $table->string('profile_photo')->nullable();
            $table->string('phone')->nullable();
            $table->float('balance')->default(0);
            $table->longText('achievements')->nullable();
            $table->longText('hobbies')->nullable();
            $table->longText('about')->nullable();
            $table->string('fb')->nullable();
            $table->string('twitter')->nullable();
            $table->string('linkedin')->nullable();
            $table->string('github')->nullable();
            $table->string('insta')->nullable();
            $table->integer('account_status')->default(1);
            $table->boolean('app_status')->default(false);
            $table->string('ref_code')->nullable();
            $table->bigInteger('ref_by')->nullable();
            $table->string('razor_contact_id')->nullable();
            $table->json('bank_acc_id')->nullable();
            $table->json('upi_acc_id')->nullable();
            $table->rememberToken();
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
        Schema::dropIfExists('users');
    }
}
