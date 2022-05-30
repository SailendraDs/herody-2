<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Application extends Model
{
    protected $table = "applications";
    public function worker()
    {
        return $this->belongsTo('App\User', 'user_id');
    }
    public function work()
    {
        return $this->belongsTo('App\Work', 'work_id');
    }
}
