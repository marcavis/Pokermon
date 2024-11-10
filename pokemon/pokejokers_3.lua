--Code for pokemon jokers 61-90
local poliwhirl={
  name = "poliwhirl", 
  pos = {x = 8, y = 4}, 
  config = {extra = {mult = 6, suits = {"Spades", "Hearts", "Clubs", "Diamonds"}, indice = 1}},
  loc_txt = {      
    name = 'Poliwhirl',      
    text = {
      "Played cards with {V:1}#2#{} suit ",
      "give {C:mult}+#1#{} Mult when scored,",
      "Suit changes in order after",
      "hand is played",
      "{C:inactive,s:0.8}(#3#, #4#, #5#, #6#){}",
      "{C:inactive,s:0.8}(Evolves with a{} {C:attention,s:0.8}Water Stone{}{C:inactive,s:0.8} or {C:attention,s:0.8}King's Rock{}{C:inactive,s:0.8} card)"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_waterstone
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_kingsrock
    return {vars = {center.ability.extra.mult, localize(center.ability.extra.suits[center.ability.extra.indice],'suits_singular'),  
                    colours = {G.C.SUITS[center.ability.extra.suits[center.ability.extra.indice]]}, localize("Spades", 'suits_plural'), localize("Hearts", 'suits_plural'), 
                    localize("Clubs", 'suits_plural'), localize("Diamonds", 'suits_plural')}}
  end,
  rarity = 2, 
  cost = 7, 
  item_req = {"waterstone", "kingsrock"},
  evo_list = {waterstone = "j_poke_poliwrath", kingsrock = "j_poke_politoed"},
  stage = "One", 
  ptype = "Water",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        if not context.blueprint then
          if card.ability.extra.indice == 4 then
            card.ability.extra.indice = 1
          else
            card.ability.extra.indice = card.ability.extra.indice + 1
          end
        end
      end
    end
    if context.individual and not context.end_of_round and context.cardarea == G.play and not context.other_card.debuff then
      local scoring_suit = card.ability.extra.suits[card.ability.extra.indice]
      if context.other_card:is_suit(scoring_suit) then
        return {
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
          colour = G.C.MULT,
          mult = card.ability.extra.mult
        }
      end
    end
    return item_evo(self, card, context)
  end,
}
local poliwrath={
  name = "poliwrath", 
  pos = {x = 9, y = 4},
  config = {extra = {Xmult_multi = 1.3, suits = {"Spades", "Hearts", "Clubs", "Diamonds"}, indice = 1, mult = 3}},
  loc_txt = {      
    name = 'Poliwrath',      
    text = {
      "Played cards with {V:1}#2#{} suit",
      "give {C:mult}+#7#{} Mult",
      "and {X:mult,C:white} X#1# {} Mult when scored,",
      "Suit changes in order after",
      "hand is played",
      "{C:inactive,s:0.8}(#3#, #4#, #5#, #6#){}"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.Xmult_multi, localize(center.ability.extra.suits[center.ability.extra.indice],'suits_singular'),  
                    colours = {G.C.SUITS[center.ability.extra.suits[center.ability.extra.indice]]}, localize("Spades", 'suits_plural'), localize("Hearts", 'suits_plural'), 
                    localize("Clubs", 'suits_plural'), localize("Diamonds", 'suits_plural'), center.ability.extra.mult}}
  end,
  rarity = "poke_safari", 
  cost = 6, 
  stage = "Two",
  ptype = "Water",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        if not context.blueprint then
          if card.ability.extra.indice == 4 then
            card.ability.extra.indice = 1
          else
            card.ability.extra.indice = card.ability.extra.indice + 1
          end
        end
      end
    end
    if context.individual and not context.end_of_round and context.cardarea == G.play and not context.other_card.debuff then
      local scoring_suit = card.ability.extra.suits[card.ability.extra.indice]
      if context.other_card:is_suit(scoring_suit) then
        return {
          x_mult = card.ability.extra.Xmult_multi,
          mult = card.ability.extra.mult,
          card = card
        }
      end
    end
  end,
}
local abra={
  name = "abra", 
  pos = {x = 10, y = 4}, 
  config = {extra = {odds = 5, rounds = 5}},
  loc_txt = {      
    name = 'Abra',      
    text = {
      "{C:green}#1# in #2#{} chance to",
      "create a {C:attention}Fool{} card if",
      "played {C:attention}poker hand{} has",
      "already been played this round",
      "{C:inactive}(Evolves after {C:attention}#3#{}{C:inactive} rounds)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = { set = 'Tarot', key = 'c_fool'}
    return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds, center.ability.extra.rounds}}
  end,
  rarity = 2, 
  cost = 6, 
  stage = "Basic", 
  ptype = "Psychic",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round > 1 then
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
          if pseudorandom('abra') < G.GAME.probabilities.normal/card.ability.extra.odds then
            local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_fool')
            _card:add_to_deck()
            G.consumeables:emplace(_card)
            card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
          end
        end
      end
    end
    return level_evo(self, card, context, "j_poke_kadabra")
  end,
}
local kadabra={
  name = "kadabra", 
  pos = {x = 11, y = 4},
  config = {extra = {odds = 4}},
  loc_txt = {      
    name = 'Kadabra',      
    text = {
      "{C:green}#1# in #2#{} chance to",
      "create a {C:attention}Fool{} card if",
      "played {C:attention}poker hand{} has",
      "already been played this round",
      "{C:inactive}(Evolves with a{} {C:attention}Linking Cord{}{C:inactive} card)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = { set = 'Tarot', key = 'c_fool'}
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_linkcable
    return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds}}
  end,
  rarity = 3, 
  cost = 8, 
  item_req = "linkcable",
  stage = "One", 
  ptype = "Psychic",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round > 1 then
        if pseudorandom('kadabra') < G.GAME.probabilities.normal/card.ability.extra.odds then
          if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_fool')
            _card:add_to_deck()
            G.consumeables:emplace(_card)
            card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
          end
        end
      end
    end
    return item_evo(self, card, context, "j_poke_alakazam")
  end,
}
local alakazam={
  name = "alakazam", 
  pos = {x = 12, y = 4}, 
  config = {extra = {odds = 3, card_limit = 1}},
  loc_txt = {      
    name = 'Alakazam',      
    text = {
      "{C:attention}+#3#{} consumable slot",
      "{C:green}#1# in #2#{} chance to",
      "create a {C:attention}Fool{} card if",
      "played {C:attention}poker hand{} has",
      "already been played this round",
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = { set = 'Tarot', key = 'c_fool'}
    return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds, center.ability.extra.card_limit}}
  end,
  rarity = "poke_safari", 
  cost = 10, 
  stage = "Two", 
  ptype = "Psychic",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round > 1 then
        if pseudorandom('alakazam') < G.GAME.probabilities.normal/card.ability.extra.odds then
          if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
          local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_fool')
            _card:add_to_deck()
            G.consumeables:emplace(_card)
            card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
          end
        end
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({func = function()
      G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.card_limit
      return true end }))
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({func = function()
      G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.card_limit
      return true end }))
  end, 
}
local machop={
  name = "machop", 
  pos = {x = 0, y = 5},
  config = {extra = {hands = 1, discards = 2, rounds = 5, mult = 4}},
  loc_txt = {      
    name = 'Machop',      
    text = {
      "{C:chips}+#1#{} hands",
      "{C:mult}-#2# discards{}",
      "{C:mult}+#4#{} Mult",
      "{C:inactive}(Evolves after {C:attention}#3#{}{C:inactive} rounds)"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
		return {vars = {center.ability.extra.hands, center.ability.extra.discards, center.ability.extra.rounds, center.ability.extra.mult}}
  end,
  rarity = 1, 
  cost = 6, 
  stage = "Basic",
  ptype = "Fighting",
  atlas = "Pokedex1",
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
          colour = G.C.MULT,
          mult_mod = card.ability.extra.mult
        }
      end
    end
    return level_evo(self, card, context, "j_poke_machoke")
  end,
  add_to_deck = function(self, card, from_debuff)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
      ease_hands_played(card.ability.extra.hands)
      G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
      ease_discard(-card.ability.extra.discards)
  end,
  remove_from_deck = function(self, card, from_debuff)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
      ease_hands_played(-card.ability.extra.hands)
      G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
      ease_discard(card.ability.extra.discards)
  end
}
local machoke={
  name = "machoke", 
  pos = {x = 1, y = 5},
  config = {extra = {hands = 2, discards = 2, mult = 12}},
  loc_txt = {      
    name = 'Machoke',      
    text = {
      "{C:chips}+#1#{} hands",
      "{C:mult}-#2# discards{}",
      "{C:mult}+#3#{} Mult",
      "{C:inactive}(Evolves with a{} {C:attention}Linking Cord{}{C:inactive} card)"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_linkcable
		return {vars = {center.ability.extra.hands, center.ability.extra.discards, center.ability.extra.mult}}
  end,
  rarity = 3, 
  cost = 8,
  item_req = "linkcable",
  stage = "One", 
  ptype = "Fighting",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
          colour = G.C.MULT,
          mult_mod = card.ability.extra.mult
        }
      end
    end
    return item_evo(self, card, context, "j_poke_machamp")
  end,
  add_to_deck = function(self, card, from_debuff)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
      ease_hands_played(card.ability.extra.hands)
      G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
      ease_discard(-card.ability.extra.discards)
  end,
  remove_from_deck = function(self, card, from_debuff)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
      ease_hands_played(-card.ability.extra.hands)
      G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
      ease_discard(card.ability.extra.discards)
  end
}
local machamp={
  name = "machamp", 
  pos = {x = 2, y = 5},
  config = {extra = {hands = 4, discards = 4, mult = 24}},
  loc_txt = {      
    name = 'Machamp',      
    text = {
      "{C:chips}+#1#{} hands",
      "{C:mult}-#2# discards{}",
      "{C:mult}+#3#{} Mult"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
		return {vars = {center.ability.extra.hands, center.ability.extra.discards, center.ability.extra.mult}}
  end,
  rarity = "poke_safari", 
  cost = 10, 
  stage = "Two", 
  ptype = "Fighting",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
          colour = G.C.MULT,
          mult_mod = card.ability.extra.mult
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
      ease_hands_played(card.ability.extra.hands)
      G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
      ease_discard(-card.ability.extra.discards)
  end,
  remove_from_deck = function(self, card, from_debuff)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
      ease_hands_played(-card.ability.extra.hands)
      G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
      ease_discard(card.ability.extra.discards)
  end
}
local bellsprout={
  name = "bellsprout", 
  pos = {x = 3, y = 5},
  config = {extra = {chips = 12, rounds = 4}},
  loc_txt = {      
    name = 'Bellsprout',      
    text = {
      "Played cards with {C:attention}Even{} rank",
      "give {C:chips}+#1#{} Chips when scored",
      "{C:inactive}(Evolves after {C:attention}#2#{}{C:inactive} rounds)"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
		return {vars = {center.ability.extra.chips, center.ability.extra.rounds}}
  end,
  rarity = 1, 
  cost = 4, 
  stage = "Basic", 
  ptype = "Grass",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      if context.other_card:get_id() == 2 or 
         context.other_card:get_id() == 4 or 
         context.other_card:get_id() == 6 or 
         context.other_card:get_id() == 8 or 
         context.other_card:get_id() == 10 then
          return {
            message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, 
            colour = G.C.CHIPS,
            chips = card.ability.extra.chips
          }
      end
    end
    return level_evo(self, card, context, "j_poke_weepinbell")
  end
}
local weepinbell={
  name = "weepinbell", 
  pos = {x = 4, y = 5},
  config = {extra = {chips = 24}},
  loc_txt = {      
    name = 'Weepinbell',      
    text = {
      "Played cards with {C:attention}Even{} rank",
      "give {C:chips}+#1#{} Chips when scored",
      "{C:inactive}(Evolves with a{} {C:attention}Leaf Stone{}{C:inactive} card)"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_leafstone
		return {vars = {center.ability.extra.chips}}
  end,
  rarity = 2, 
  cost = 7, 
  item_req = "leafstone",
  stage = "One", 
  ptype = "Grass",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      if context.other_card:get_id() == 2 or 
         context.other_card:get_id() == 4 or 
         context.other_card:get_id() == 6 or 
         context.other_card:get_id() == 8 or 
         context.other_card:get_id() == 10 then
          return {
            message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, 
            colour = G.C.CHIPS,
            chips = card.ability.extra.chips
          }
      end
    end
    return item_evo(self, card, context, "j_poke_victreebel")
  end
}
local victreebel={
  name = "victreebel", 
  pos = {x = 5, y = 5},
  config = {extra = {chips = 12, retriggers = 1}},
  loc_txt = {      
    name = 'Victreebel',      
    text = {
      "Played cards with {C:attention}Even{} rank",
      "give {C:chips}+#1#{} Chips when scored",
      "and {C:attention}retrigger{}"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
		return {vars = {center.ability.extra.chips}}
  end,
  rarity = "poke_safari", 
  cost = 6, 
  stage = "Two", 
  ptype = "Grass",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      if context.other_card:get_id() == 2 or 
         context.other_card:get_id() == 4 or 
         context.other_card:get_id() == 6 or 
         context.other_card:get_id() == 8 or 
         context.other_card:get_id() == 10 then
          return {
            message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, 
            colour = G.C.CHIPS,
            chips = card.ability.extra.chips
          }
      end
    end
    if context.repetition and context.cardarea == G.play and not context.other_card.debuff then
      if context.other_card:get_id() == 2 or 
         context.other_card:get_id() == 4 or 
         context.other_card:get_id() == 6 or 
         context.other_card:get_id() == 8 or 
         context.other_card:get_id() == 10 then
          return {
            message = localize('k_again_ex'),
            repetitions = card.ability.extra.retriggers,
            card = card
          }
      end
    end
  end
}
local tentacool={
  name = "tentacool", 
  pos = {x = 6, y = 5},
  config = {extra = {mult = 5, rounds = 5}},
  loc_txt = {      
    name = 'Tentacool',      
    text = {
      "Each played {C:attention}10{}",
      "gives {C:mult}+#1#{} Mult when scored",
      "if hand only contains {C:attention}10{}s",
      "{C:inactive}(Evolves after {C:attention}#2#{}{C:inactive} rounds)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.mult, center.ability.extra.rounds}}
  end,
  rarity = 1, 
  cost = 6, 
  stage = "Basic", 
  ptype = "Water",
  atlas = "Pokedex1", 
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff and context.other_card:get_id() == 10 then
      local allten = true
      for k, v in pairs(context.scoring_hand) do
        if v:get_id() ~= 10 then
          allten = false
          break
        end
      end
      if allten then
        return {
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
          colour = G.C.MULT,
          mult = card.ability.extra.mult
        }
      end
    end
    return level_evo(self, card, context, "j_poke_tentacruel")
  end
}
local tentacruel={
  name = "tentacruel", 
  pos = {x = 7, y = 5}, 
  config = {extra = {mult = 8}},
  loc_txt = {      
    name = 'Tentacruel',      
    text = {
      "Each played {C:attention}10{}",
      "gives {C:mult}+#1#{} Mult when scored",
      "{C:attention}10s can't{} be debuffed"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.mult}}
  end,
  rarity = 3, 
  cost = 8, 
  stage = "One", 
  ptype = "Water",
  atlas = "Pokedex1", 
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff and context.other_card:get_id() == 10 then
      return {
        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
        colour = G.C.MULT,
        mult = card.ability.extra.mult
      }
    end
  end
}
local geodude={
  name = "geodude", 
  pos = {x = 8, y = 5}, 
  config = {extra = {chips = 75, h_size = 1, rounds = 4}},
  loc_txt = {      
    name = 'Geodude',      
    text = {
      "{C:chips}+#1#{} Chips,",
      "{C:attention}-#2#{} hand size",
      "{C:inactive}(Evolves after {C:attention}#3#{}{C:inactive} rounds)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.chips, center.ability.extra.h_size, center.ability.extra.rounds}}
  end,
  rarity = 1, 
  cost = 6, 
  stage = "Basic",
  ptype = "Earth",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, 
          colour = G.C.CHIPS,
          chip_mod = card.ability.extra.chips
        }
      end
    end
    return level_evo(self, card, context, "j_poke_graveler")
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end
}
local graveler={
  name = "graveler", 
  pos = {x = 9, y = 5},
  config = {extra = {chips = 175, h_size = 2, rounds = 0}},
  loc_txt = {      
    name = 'Graveler',      
    text = {
      "{C:chips}+#1#{} Chips,",
      "{C:attention}-#2#{} hand size",
      "{C:inactive}(Evolves with a{} {C:attention}Linking Cord{}{C:inactive} card)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_linkcable
    return {vars = {center.ability.extra.chips, center.ability.extra.h_size}}
  end,
  rarity = 3, 
  cost = 8, 
  item_req = "linkcable",
  stage = "One", 
  ptype = "Earth",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, 
          colour = G.C.CHIPS,
          chip_mod = card.ability.extra.chips
        }
      end
    end
    if not context.repetition and not context.individual and context.end_of_round and card.ability.extra.evolve then
      return {
        message = evolve (self, card, context, 'j_poke_golem')
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end
}
local golem={
  name = "golem", 
  pos = {x = 10, y = 5},
  config = {extra = {chips = 275, h_size = 3, rounds = 0}},
  loc_txt = {      
    name = 'Golem',      
    text = {
      "{C:chips}+#1#{} Chips,",
      "{C:attention}-#2#{} hand size",
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.chips, center.ability.extra.h_size}}
  end,
  rarity = "poke_safari", 
  cost = 10, 
  stage = "Two", 
  ptype = "Earth",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, 
          colour = G.C.CHIPS,
          chip_mod = card.ability.extra.chips
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end
}
local ponyta={
  name = "ponyta", 
  pos = {x = 11, y = 5},
  config = {extra = {chips = 0, chip_mod = 10}},
  loc_txt = {      
    name = 'Ponyta',     
    text = {
      "Gains {C:chips}#2#{} Chips if played", 
      "hand contains a {C:attention}Straight{}",
      "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
      "{C:inactive}(Evolves at {C:chips}+60{} {C:inactive}Chips)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.chips, center.ability.extra.chip_mod}}
  end,
  rarity = 1, 
  cost = 6, 
  stage = "Basic", 
  ptype = "Fire",
  atlas = "Pokedex1", 
  perishable_compat = false,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.before and not context.blueprint and context.cardarea == G.jokers and next(context.poker_hands['Straight']) then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
        return {
            message = localize('k_upgrade_ex'),
            colour = G.C.CHIPS,
            card = card
        }
      end
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, 
          colour = G.C.CHIPS,
          chip_mod = card.ability.extra.chips
        }
      end
    end
    return scaling_evo(self, card, context, "j_poke_rapidash", card.ability.extra.chips, 60)
  end,
}
local rapidash={
  name = "rapidash", 
  pos = {x = 12, y = 5},
  config = {extra = {chips = 105, chip_mod = 10}},
  loc_txt = {      
    name = 'Rapidash',      
    text = {
      "Gains {C:chips}#2#{} Chips if played", 
      "hand contains a {C:attention}Straight{}",
      "Applies {C:attention}Shortcut{} for first hand",
      "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = { set = 'Joker', key = 'j_shortcut'}
    return {vars = {center.ability.extra.chips, center.ability.extra.chip_mod}}
  end,
  rarity = 3, 
  cost = 8, 
  stage = "One", 
  ptype = "Fire",
  atlas = "Pokedex1",
  perishable_compat = false,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.before and not context.blueprint and context.cardarea == G.jokers and next(context.poker_hands['Straight']) then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
        return {
            message = localize('k_upgrade_ex'),
            colour = G.C.CHIPS,
            card = card
        }
      end
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, 
          colour = G.C.CHIPS,
          chip_mod = card.ability.extra.chips
        }
      end
    end
  end,
}
local slowpoke={
  name = "slowpoke", 
  pos = {x = 0, y = 6}, 
  config = {extra = {Xmult = 2, rounds = 5}},
  loc_txt = {      
    name = 'Slowpoke',      
    text = {
      "{X:red,C:white} X#1# {} Mult on {C:attention}final",
      "{C:attention}hand{} of round",
      "{C:inactive}(Evolves after {C:attention}#2#{}{C:inactive} rounds)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.Xmult, center.ability.extra.rounds}}
  end,
  rarity = 1, 
  cost = 6, 
  stage = "Basic", 
  ptype = "Water",
  atlas = "Pokedex1", 
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main and G.GAME.current_round.hands_left == 0 then
        return {
          message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, 
          colour = G.C.XMULT,
          Xmult_mod = card.ability.extra.Xmult
        }
      end
    end
    return level_evo(self, card, context, "j_poke_slowbro")
  end
}
local slowpoke2={
  name = "slowpoke", 
  pos = {x = 0, y = 6}, 
  config = {extra = {Xmult = 2, rounds = 5, odds = 4}},
  loc_txt = {      
    name = 'Slowpoke',      
    text = {
      "{X:red,C:white} X#1# {} Mult on {C:attention}final {C:attention}hand{} of round",
      "{C:green}#3# in #4#{} chance to create",
      "a {C:attention}King's Rock{} card at",
      "end of round {C:inactive,s:0.8}(Must have room){}",
      "{C:inactive,s:0.8}(Evolves after {C:attention,s:0.8}#2#{}{C:inactive,s:0.8} rounds or with a {C:attention,s:0.8}King's Rock{} {C:inactive,s:0.8}card)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.Xmult, center.ability.extra.rounds, ''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds}}
  end,
  rarity = 1, 
  cost = 6, 
  item_req = "kingsrock",
  stage = "Basic", 
  ptype = "Water",
  atlas = "Pokedex1", 
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main and G.GAME.current_round.hands_left == 0 then
        return {
          message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, 
          colour = G.C.XMULT,
          Xmult_mod = card.ability.extra.Xmult
        }
      end
    end
    if not context.repetition and not context.individual and context.end_of_round then
      if (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) and (pseudorandom('slowpoke') < G.GAME.probabilities.normal/card.ability.extra.odds) then
        local _card = create_card('Item', G.consumeables, nil, nil, nil, nil, "c_poke_kingsrock")
        _card:add_to_deck()
        G.consumeables:emplace(_card)
      end
    end
    local evo = item_evo(self, card, context, "j_poke_slowking")
    if not evo then
      evo = level_evo(self, card, context, "j_poke_slowbro")
    end
    return evo
  end
}
local slowbro={
  name = "slowbro", 
  pos = {x = 1, y = 6}, 
  config = {extra = {Xmult_multi = 0.5, Xmult = 1, oXmult = 1}},
  loc_txt = {      
    name = 'Slowbro',      
    text = {
      "Gains {X:red,C:white} X#1# {} Mult",
      "per hand played,",
      "resets at end of round",
      "{C:inactive}(Currently {X:red,C:white} X#2# {}{C:inactive} Mult)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.Xmult_multi, center.ability.extra.Xmult}}
  end,
  rarity = "poke_safari", 
  cost = 6, 
  stage = "One", 
  ptype = "Water",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.first_hand_drawn then
      card.ability.extra.oXmult = card.ability.extra.Xmult_multi
    end
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        if not context.blueprint then
          card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_multi
        end
        return {
          message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, 
          colour = G.C.XMULT,
          Xmult_mod = card.ability.extra.Xmult
        }
      end
    elseif not context.repetition and not context.individual and context.end_of_round and not context.blueprint then
      card.ability.extra.Xmult = card.ability.extra.oXmult
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end
}
local magnemite={
  name = "magnemite", 
  pos = {x = 2, y = 6}, 
  config = {extra = {Xmult_multi = 1.3, rounds = 4}},
  loc_txt = {      
    name = 'Magnemite',      
    text = {
      "Played {C:attention}Steel{} cards",
      "give {X:red,C:white}X#1#{} Mult",
      "{C:inactive}(Evolves after {C:attention}#2#{}{C:inactive} rounds)"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    return {vars = {center.ability.extra.Xmult_multi, center.ability.extra.rounds}}
  end,
  rarity = 2, 
  cost = 7,
  enhancement_gate = 'm_steel',
  stage = "Basic",
  ptype = "Lightning",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and
       context.other_card.ability.name == 'Steel Card' then
        return {
          message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult_multi}}, 
          colour = G.C.XMULT,
          x_mult = card.ability.extra.Xmult_multi
        }
    end
    return level_evo(self, card, context, "j_poke_magneton")
  end
}
local magneton={
  name = "magneton", 
  pos = {x = 3, y = 6}, 
  config = {extra = {Xmult_multi = 1.6}},
  loc_txt = {      
    name = 'Magneton',      
    text = {
      "Played {C:attention}Steel{} cards",
      "give {X:red,C:white}X#1#{} Mult",
      "{C:inactive}(Evolves with a {C:attention}Thunder Stone{}{C:inactive})"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_thunderstone
    return {vars = {center.ability.extra.Xmult_multi}}
  end,
  rarity = "poke_safari", 
  cost = 6, 
  enhancement_gate = 'm_steel',
  stage = "One", 
  ptype = "Lightning",
  atlas = "Pokedex1",
  item_req = "thunderstone",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and
       context.other_card.ability.name == 'Steel Card' then
        return {
          message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult_multi}}, 
          colour = G.C.XMULT,
          x_mult = card.ability.extra.Xmult_multi
        }
    end
    return item_evo(self, card, context, "j_poke_magnezone")
  end
}
local farfetchd={
  name = "farfetchd", 
  pos = {x = 4, y = 6}, 
  config = {extra = {Xmult = 3, odds = 4}},
  loc_txt = {      
    name = 'Farfetch\'d',      
    text = {
      "When you get this,",
      "create a {C:attention}Leek{} card.",
      "{C:green}#2# in #3#{} chance for {X:red,C:white}X#1#{} Mult",
      "The chance is doubled for",
      "each {C:attention}Leek{} card you have",
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_leek
    return {vars = {center.ability.extra.Xmult, ''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds}}
  end,
  rarity = 2, 
  cost = 6, 
  stage = "Basic", 
  ptype = "Colorless",
  joblacklist = true,
  atlas = "Pokedex1",
  blueprint_compat = true,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
      local _card = create_card('Item', G.consumeables, nil, nil, nil, nil, 'c_poke_leek')
      _card:add_to_deck()
      G.consumeables:emplace(_card)
      card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
      return true
    end
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      local count = #find_joker('leek')
      local chance
      if count > 0 then
        chance = G.GAME.probabilities.normal * 2 * count
      else
        chance = G.GAME.probabilities.normal
      end
      if context.joker_main and pseudorandom('farfet') < chance/card.ability.extra.odds then
        return {
          message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, 
          colour = G.C.XMULT,
          Xmult_mod = card.ability.extra.Xmult
        }
      end
    end
  end
}
local doduo={
  name = "doduo", 
  pos = {x = 5, y = 6}, 
  config = {extra = {mult = 12, rounds = 4}},
  loc_txt = {      
    name = 'Doduo',      
    text = {
      "{C:mult}+#1#{} Mult if scoring hand",
      "contains at least",
      "{C:attention}2{} face cards",
      "{C:inactive}(Evolves after {C:attention}#2#{}{C:inactive} rounds)"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.mult, center.ability.extra.rounds}}
  end,
  rarity = 1, 
  cost = 5, 
  stage = "Basic", 
  ptype = "Colorless",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        local face_count = 0
        for i = 1, #context.scoring_hand do
          if context.scoring_hand[i]:is_face() then
            face_count = face_count + 1
          end
        end
        if face_count > 1 then
          return {
            message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
            colour = G.C.MULT,
            mult_mod = card.ability.extra.mult
          }
        end
      end
    end
    return level_evo(self, card, context, "j_poke_dodrio")
  end
}
local dodrio={
  name = "dodrio", 
  pos = {x = 6, y = 6}, 
  config = {extra = {mult = 33}},
  loc_txt = {      
    name = 'Dodrio',      
    text = {
      "{C:mult}+#1#{} Mult if scoring hand",
      "contains at least",
      "{C:attention}3{} face cards"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.mult}}
  end,
  rarity = 2, 
  cost = 7, 
  stage = "One", 
  ptype = "Colorless",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        local face_count = 0
        for i = 1, #context.scoring_hand do
          if context.scoring_hand[i]:is_face() then
            face_count = face_count + 1
          end
        end
        if face_count > 2 then
          return {
            message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
            colour = G.C.MULT,
            mult_mod = card.ability.extra.mult
          }
        end
      end
    end
  end
}
local seel={
  name = "seel", 
  pos = {x = 7, y = 6}, 
  config = {extra = {odds = 2, rounds = 5}},
  loc_txt = {      
    name = 'Seel',      
    text = {
      "If {C:attention}first hand{} of round", 
      "has only {C:attention}1{} card, {C:green}#1# in #2#{} chance to",
      "add a random {C:attention}seal{} to that card",
      "{C:inactive}(Evolves after {C:attention}#3#{}{C:inactive} rounds)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds, center.ability.extra.rounds}}
  end,
  rarity = 2, 
  cost = 7, 
  stage = "Basic", 
  ptype = "Water",
  atlas = "Pokedex1",
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not context.blueprint then
      if pseudorandom('seel') < G.GAME.probabilities.normal/card.ability.extra.odds then
        _card = context.full_hand[1]
        local args = {guaranteed = true}
        local seal_type = SMODS.poll_seal(args)
        _card:set_seal(seal_type, true)
      end
    end
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    return level_evo(self, card, context, "j_poke_dewgong")
  end
}
local dewgong={
  name = "dewgong", 
  pos = {x = 8, y = 6}, 
  loc_txt = {      
    name = 'Dewgong',      
    text = {
      "If {C:attention}first hand{} of round", 
      "has only {C:attention}1{} card, add a",
      "random {C:attention}seal{} to that card",
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
  end,
  rarity = 3, 
  cost = 9, 
  stage = "One", 
  ptype = "Water",
  atlas = "Pokedex1",
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not context.blueprint then
      _card = context.full_hand[1]
      local args = {guaranteed = true}
      local seal_type = SMODS.poll_seal(args)
      _card:set_seal(seal_type, true)
    end
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
  end
}
local grimer={
  name = "grimer", 
  pos = {x = 9, y = 6}, 
  config = {extra = {mult = 6, rounds = 5}},
  loc_txt = {      
    name = 'Grimer',      
    text = {
      "{C:mult}+#1#{} Mult if",
      "deck size > {C:attention}#3#{}",
      "Add a random playing card",
      "to your deck at end of round",
      "{C:inactive}(Evolves after {C:attention}#2#{}{C:inactive} rounds)"
    } 
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.mult, center.ability.extra.rounds, G.GAME.starting_deck_size}}
  end,
  rarity = 1, 
  cost = 5, 
  stage = "Basic", 
  ptype = "Dark",
  atlas = "Pokedex1", 
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main and #G.playing_cards > G.GAME.starting_deck_size then
        return {
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
          colour = G.C.MULT,
          mult_mod = card.ability.extra.mult
        }
      end
    end
    if context.end_of_round and not context.individual and not context.repetition then
      local _card = create_playing_card({
        front = pseudorandom_element(G.P_CARDS, pseudoseed('grimer')), 
        center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.PURPLE
      })
      playing_card_joker_effects({card})
      card:juice_up()
    end
    return level_evo(self, card, context, "j_poke_muk")
  end,
}
local muk={
  name = "muk", 
  pos = {x = 10, y = 6}, 
  config = {extra = {mult = 1, Xmult = 1.5}},
  loc_txt = {      
    name = 'Muk',      
    text = {
      "{C:mult}+#1#{} Mult for every card",
      "above {C:attention}#3#{} in your full deck",
      "{X:mult,C:white} X#2# {} Mult if deck size > {C:attention}#4#{}",
      "{C:inactive,s:0.8}(Currently {C:mult,s:0.8}+#5#{} {C:inactive,s:0.8}Mult){}",
      "Add two random playing cards to deck",
      "and remove one random card from deck",
      "at end of round"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.mult, center.ability.extra.Xmult, G.GAME.starting_deck_size, G.GAME.starting_deck_size + 12, 
                    (G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0)}}
  end,
  rarity = 3, 
  cost = 8, 
  stage = "One", 
  ptype = "Dark",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main and #G.playing_cards > G.GAME.starting_deck_size then
        local Xmult
        if #G.playing_cards > G.GAME.starting_deck_size + 12 then
          Xmult = card.ability.extra.Xmult
        else
          Xmult = 1
        end
        return {
          message = "Sludge!", 
          colour = G.C.XMULT,
          mult_mod = card.ability.extra.mult * (#G.playing_cards - G.GAME.starting_deck_size),
          Xmult_mod = Xmult
        }
      end
    end
    if context.end_of_round and not context.individual and not context.repetition then
      local cards = {}
      for i = 1, 2 do
        cards[i] = create_playing_card({
          front = pseudorandom_element(G.P_CARDS, pseudoseed('muk')), 
          center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.PURPLE
        })
      end
      playing_card_joker_effects(cards);
      local target = pseudorandom_element(G.playing_cards, pseudoseed('muk'))
      G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.2,
          func = function() 
              if target.ability.name == 'Glass Card' then 
                  target:shatter()
              else
                  target:start_dissolve()
              end
          return true end }))
      delay(0.3)
      for i = 1, #G.jokers.cards do
          G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = {target}})
      end
      card:juice_up()
    end
  end,
}
local shellder={
  name = "shellder", 
  pos = {x = 11, y = 6}, 
  config = {extra = {retriggers = 1, odds = 3}},
  loc_txt = {      
    name = 'Shellder',      
    text = {
      "If hand has {C:attention}5{} scoring",
      "cards, each have a {C:green}#1# in #2#{}",
      "chance to retrigger",
      "{C:inactive}(Evolves with a{} {C:attention}Water Stone{}{C:inactive} card)"
    } 
  }, 
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_waterstone
    return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds}}
  end,
  rarity = 2, 
  cost = 5, 
  item_req = "waterstone",
  stage = "Basic",
  ptype = "Water",
  atlas = "Pokedex1",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play and #context.scoring_hand == 5 then
      if not context.end_of_round and not context.before and not context.after and not context.other_card.debuff then
        if pseudorandom('shellder') < G.GAME.probabilities.normal/card.ability.extra.odds then
          return {
            message = localize('k_again_ex'),
            repetitions = card.ability.extra.retriggers,
            card = card
          }
        end
      end
    end
    return item_evo(self, card, context, "j_poke_cloyster")
  end,
}

local slowpoke_to_use = nil
if pokermon_config.no_evos then
  slowpoke_to_use = slowpoke
else
  slowpoke_to_use = slowpoke2
end

return {name = "Pokemon Jokers 61-90", 
        list = { poliwhirl, poliwrath, abra, kadabra, alakazam, machop, machoke, machamp, bellsprout, weepinbell, victreebel, tentacool, tentacruel, geodude, graveler, 
                 golem, ponyta, rapidash, slowpoke_to_use, slowbro, magnemite, magneton, farfetchd, doduo, dodrio, seel, dewgong, grimer, muk, shellder, },
}