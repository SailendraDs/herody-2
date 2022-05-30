<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Support extends Model
{
    protected $table = "supports";
    /**
     * Get all of the chats for the Support
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function chats(): HasMany
    {
        return $this->hasMany(Support::class, 'support_id');
    }
}
