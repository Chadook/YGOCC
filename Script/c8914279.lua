--Garbage Witcher
function c8914279.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1,8914279)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c8914279.spcon)
	c:RegisterEffect(e1)
    --lvchange
	local e2=Effect.CreateEffect(c)
	e2:SetCountLimit(1,8914279)
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c8914279.lvtg)
	e2:SetOperation(c8914279.lvop)
	c:RegisterEffect(e2)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c8914279.xyzlimit)
	c:RegisterEffect(e3)
end
function c8914279.xyzlimit(e,c)
if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c8914279.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8914279.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c8914279.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x71a) or (c:IsCode(18698739) or c:IsCode(44682448))
end
function c8914279.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x71a) or (c:IsCode(18698739) or c:IsCode(44682448)) and c:GetLevel()>=1
end
function c8914279.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c8914279.lvfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c8914279.lvfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	g2=Duel.SelectTarget(tp,c8914279.lvfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c8914279.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end