<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class JoinTeamCategory extends Model
{
    protected $table = "join_team_categories";
    /**
     * Get all of the forms for the JoinTeamCategory
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function forms(): HasMany
    {
        return $this->hasMany(JoinTeamForm::class, 'category_id');
    }
}
