<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class JoinTeamForm extends Model
{
    protected $table = "join_team_forms";
    /**
     * Get the category that owns the JoinTeamForm
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function category(): BelongsTo
    {
        return $this->belongsTo(JoinTeamCategory::class, 'category_id');
    }
}
