<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Chat extends Model
{
    protected $table = "chats";
    /**
     * Get the support that owns the Chat
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function support(): BelongsTo
    {
        return $this->belongsTo(Support::class, 'support_id');
    }
}
