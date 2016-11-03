--Bladewing Tara
function c101010349.initial_effect(c)
--pierce
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--When this card is Normal Summoned: You can shuffle 3 "Blademaster" or "Bladewing" monsters from your hand or Graveyard into the Deck, and if you do, draw 2 cards.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c101010349.target)
	e2:SetOperation(c101010349.operation)
	c:RegisterEffect(e2)
end
function c101010349.filter(c)
	return (c:IsSetCard(0xbb2) or c:IsSetCard(0xbb3)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c101010349.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010349.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,3,nil) end
	local g=Duel.GetMatchingGroup(c101010349.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
end
function c101010349.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c101010349.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,3,3,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		if g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==3 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end

