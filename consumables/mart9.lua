local repeatball = {
    name = "repeatball",
    key = "repeatball",
    set = "Item",
    loc_vars = function(self, info_queue, center)
    --  info_queue[#info_queue+1] = {set = 'Other', key = 'basic'}
     return {vars = {}}
    end,
    pos = { x = 0, y = 3 },
    atlas = "Mart",
    cost = 10,
    pokeball = true,
    unlocked = true,
    discovered = true,
    can_use = function(self, card)
      if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
          return true
      else
          return false
      end
    end,
    use = function(self, card, area, copier)
      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          play_sound('timpani')
        --   local _card = create_repeated_poke_joker("pokeball")
          local _card = create_repeated_poke_joker("pokeball")
          _card:add_to_deck()
          G.jokers:emplace(_card)
          return true end }))
      delay(0.6)
    end,
    in_pool = function(self)
        if G.jokers and G.jokers.cards and #G.jokers.cards > 0 then
            return true
        else
            return false
        end
    end  
  }

  create_repeated_poke_joker = function(pseed, area, poketype)
    local poke_keys = {}
    local pokearea = area or G.jokers
    local poke_key
    local create_args = {set = "Joker", area = pokearea, key = ''}
    
    for k, v in pairs(G.jokers.cards) do
        local thiskey = "j_poke_" .. v.ability.name
      if get_poke_allowed(thiskey) then
        table.insert(poke_keys, thiskey)
      end
    end
    
    if #poke_keys > 0 then
      poke_key = pseudorandom_element(poke_keys, pseudoseed(pseed))
    else
      poke_key = "j_poke_caterpie"
    end
    create_args.key = poke_key
  
    return SMODS.create_card(create_args)
  end

  local list = {repeatball}

  return {name = "Mart 9",
        list = list
}