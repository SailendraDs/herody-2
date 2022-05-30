<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Work extends Model
{
    protected $table = "works";
    public function employer()
    {
        return $this->belongsTo('App\Employer', 'user_id');
    }
    public function applications()
    {
        return $this->hasMany('App\Application', 'work_id');
    }
}
