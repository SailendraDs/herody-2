<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateWorksTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('works', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->bigInteger('user_id');
            $table->boolean('approved')->default(0);
            $table->string('name');
            $table->string('duration');
            $table->string('type');
            $table->string('comment');
            $table->mediumText('description');
            $table->string('category');
            $table->mediumText('about');
            $table->string('pricing');
            $table->json('objectives');
            $table->json('responsibilities');
            $table->date('last_apply');
            $table->date('last_complete');
            $table->double('price', 15, 8);
            $table->integer('candidates');
            $table->json('questions');
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
        Schema::dropIfExists('works');
    }
}
