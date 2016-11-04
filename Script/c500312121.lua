--Cursed Portrait's Hand
function c500312121.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500312121,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c500312121.cost)
	e1:SetOperation(c500312121.activate)
	c:RegisterEffect(e1)
	
	end
	function c500312121.cfilter(c)
	return  c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end


function c500312121.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500312121.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c500312121.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c500312121.activate(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,2,nil)
if g:GetCount()>0 then
    Duel.HintSelection(g)
    local tc=g:GetFirst()
    while tc do
        tc:AddCounter(0x1075,1)
        tc=g:GetNext()
    end
end
end