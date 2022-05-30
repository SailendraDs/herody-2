<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateJoinTeamsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('join_teams', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('heading')->default('Join Team');
            $table->longText('description')->default('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sapien faucibus et molestie ac feugiat sed. Ut ornare lectus sit amet est placerat. Tellus pellentesque eu tincidunt tortor aliquam. Scelerisque fermentum dui faucibus in ornare quam viverra. Egestas pretium aenean pharetra magna ac placerat vestibulum lectus mauris. Faucibus nisl tincidunt eget nullam. Urna et pharetra pharetra massa massa ultricies mi. Nisi quis eleifend quam adipiscing vitae. Semper feugiat nibh sed pulvinar proin gravida. Semper auctor neque vitae tempus quam pellentesque nec. Pellentesque elit ullamcorper dignissim cras tincidunt lobortis. Nulla malesuada pellentesque elit eget gravida. Lacus viverra vitae congue eu consequat ac felis donec. Dolor sit amet consectetur adipiscing elit pellentesque habitant. Blandit libero volutpat sed cras. Sapien pellentesque habitant morbi tristique senectus et netus et malesuada. Eget velit aliquet sagittis id consectetur purus ut.');
            $table->string('image')->default('logo.png');
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
        Schema::dropIfExists('join_teams');
    }
}
