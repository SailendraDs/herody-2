<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class CustomProjectCategory extends Model
{
    protected $table = "custom_project_categories";
    /**
     * Get all of the forms for the CustomProjectCategory
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function forms(): HasMany
    {
        return $this->hasMany(CustomProjectForm::class, 'category_id');
    }
}
