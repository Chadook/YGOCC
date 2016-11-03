--Ragna Clarissa of Stellar Vine
function c101010217.initial_effect(c)
	--refill Once per turn, during either player's turn, when a banished "Stellar Vine" monster is returned to the Graveyard: you can banish 1 "Stellar Vine" monster from your Deck. If this card would be sent to the Graveyard from the field or as an Xyz Material, banish it instead.
	local ae3=Effect.CreateEffect(c)
	ae3:SetCategory(CATEGORY_REMOVE)
	ae3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ae3:SetCode(EVENT_TO_GRAVE)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCountLimit(1)
	ae3:SetCondition(c101010217.condition)
	ae3:SetTarget(c101010217.target)
	ae3:SetOperation(c101010217.operation)
	c:RegisterEffect(ae3)
	if not spatial_check then
		spatial_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010217.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010217.spatial=true
--Spatial Formula filter(s)
c101010217.material=function(mc) return mc:IsAttribute(ATTRIBUTE_WATER) and mc:IsSetCard(0x785e) end
function c101010217.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,500)
	Duel.CreateToken(1-tp,500)
end
--when a banished "Stellar Vine" monster is returned to the Graveyard
function c101010217.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x785e)
end
--you can banish 1 "Stellar Vine" monster from your Deck.
function c101010217.filter2(c)
	return c:IsSetCard(0x785e) and c:IsAbleToRemove()
end
function c101010217.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010217.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c101010217.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010217.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
