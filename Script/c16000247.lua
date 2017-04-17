--Kumina,Priestess of Maginifcent Vine
function c16000247.initial_effect(c)
	c:SetSPSummonOnce(16000247)
	--c:EnableReviveLimit()
	--special summon
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_SPSUMMON_PROC)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	--e2:SetCondition(c16000247.spcon)
	---e2:SetOperation(c16000247.spop)
	--c:RegisterEffect(e2)
		--lv change
	local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(16000247,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetCost(c16000247.discost)
	e1:SetTarget(c16000247.target)
	e1:SetOperation(c16000247.operation)
	c:RegisterEffect(e1)
		--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c16000247.xyzlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	--local e5=e3:Clone()
	--e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	--c:RegisterEffect(e5)
end
function c16000247.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785c) and not c:IsCode(16000247) and c:IsAbleToGraveAsCost()
end
function c16000247.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16000247.spfilter,tp,LOCATION_HAND,0,2,c)
end
function c16000247.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16000247.spfilter,tp,LOCATION_HAND,0,2,2,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c16000247.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x785c)and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1)
end
function c16000247.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c16000247.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c16000247.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16000247.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c16000247.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(16000247,0))
	else op=Duel.SelectOption(tp,aux.Stringid(16000247,0),aux.Stringid(16000247,1),aux.Stringid(16000247,2)) end
	e:SetLabel(op)
end
function c16000247.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(c16000247.xyzlimit)
	tc:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	tc:RegisterEffect(e5)
	if e:GetLabel()==0 then
				local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_UPDATE_LEVEL)
		e4:SetValue(tc:GetLevel())
		c:RegisterEffect(e4)
	else if e:GetLabel()==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(2)
		tc:RegisterEffect(e1)
		else if e:GetLabel()==2 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(-2)
		tc:RegisterEffect(e3)
	

	end

	end
	end
	end
	
	end
	function c16000247.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x785c)
end