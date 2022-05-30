<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class Employer extends Authenticatable
{
    use Notifiable;
    protected $guard = 'employers';
    protected $table = 'employers';
    public function works()
    {
        return $this->hasMany('App\Work', 'user_id');
    }
}
