<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CustomProjectForm extends Model
{
    protected $table = "custom_project_forms";
    /**
     * Get the category that owns the CustomProjectForm
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function category(): BelongsTo
    {
        return $this->belongsTo(CustomProjectCategory::class, 'category_id');
    }
}
