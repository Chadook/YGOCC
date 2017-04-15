--Moirai, Shaderune of Fate
function c6666674.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6666674,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,6666674)
	e1:SetTarget(c6666674.target)
	e1:SetOperation(c6666674.operation)
	c:RegisterEffect(e1)
	--banish deck check
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6666674,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c6666674.condition)
	e2:SetTarget(c6666674.btarget)
	e2:SetOperation(c6666674.boperation)
	c:RegisterEffect(e2)
end
function c6666674.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(tp,2):IsExists(Card.IsAbleToRemove,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
end
function c6666674.cfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function c6666674.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local ct=g:FilterCount(c6666674.cfilter,nil)
	if ct==0 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
	local h1=Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c6666674.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c6666674.btarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
end
function c6666674.cfilter(c)
	return c:IsSetCard(0x900) or c:IsSetCard(0x901)
end
function c6666674.boperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,2)
	local g=Duel.GetDecktopGroup(tp,2)
	if g:GetCount()>0 then
		local sg=g:Filter(c6666674.cfilter,nil)
		if sg:GetCount()>0 then
			if sg:GetFirst():IsAbleToRemove() then
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
